package shop

import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.Row
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Remove
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.res.painterResource

@Composable
fun QuantityStepper(quantity: Int, onDecrease: () -> Unit) {
    Row {
        IconButton(onClick = onDecrease) {
            Icon(Icons.Filled.Remove, contentDescription = null)
        }
        Text("$quantity")
        Image(
            painter = painterResource(id = R.drawable.everyday_tote),
        )
    }
}
