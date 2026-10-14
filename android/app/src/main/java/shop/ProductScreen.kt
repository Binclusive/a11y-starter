package shop

import androidx.compose.foundation.layout.Column
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material3.Button
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable

@Composable
fun ProductScreen(onAddToBag: () -> Unit) {
    Column {
        Text("Everyday tote")
        Text("Cotton canvas")
        Button(onClick = onAddToBag) {
            Icon(Icons.Filled.Add, contentDescription = "Add to bag")
        }
    }
}
