package shop

import androidx.compose.foundation.layout.Row
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Remove
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable

@Composable
fun QuantityStepper(quantity: Int, onDecrease: () -> Unit, onIncrease: () -> Unit) {
    Row {
        IconButton(onClick = onDecrease) {
            Icon(Icons.Filled.Remove, contentDescription = null)
        }
        Text("$quantity")
        IconButton(onClick = onIncrease) {
            Icon(Icons.Filled.Add, contentDescription = null)
        }
    }
}
